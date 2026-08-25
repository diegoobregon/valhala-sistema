$base = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\java\pe\valhala\backend"
$utf8 = New-Object System.Text.UTF8Encoding $false
function W($rel, $content) {
    $path = Join-Path $base $rel
    $dir = Split-Path $path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($path, $content, $utf8)
    Write-Host "OK $rel"
}

# ================= EXCEPCIONES DE NEGOCIO =================
W "exception\ColisionReservaException.java" @'
package pe.valhala.backend.exception;
public class ColisionReservaException extends RuntimeException {
    public ColisionReservaException() { super("RF-01: El equipo ya tiene una reserva activa en esas fechas (Colision detectada)."); }
}
'@
W "exception\DocumentoVencidoException.java" @'
package pe.valhala.backend.exception;
public class DocumentoVencidoException extends RuntimeException {
    public DocumentoVencidoException() { super("RF-06: Bloqueo de despacho. El equipo tiene documentos legales (SOAT/TREC) vencidos."); }
}
'@
W "exception\FraudeHorometroException.java" @'
package pe.valhala.backend.exception;
public class FraudeHorometroException extends RuntimeException {
    public FraudeHorometroException() { super("RF-05: Fraude detectado. El horometro final no puede ser menor al inicial."); }
}
'@

# ================= MANEJADOR GLOBAL (Seccion 2.8.2) =================
W "exception\GlobalExceptionHandler.java" @'
package pe.valhala.backend.exception;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import pe.valhala.backend.security.CredencialesInvalidasException;
import java.time.LocalDateTime;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(ColisionReservaException.class)
    public ResponseEntity<Map<String, Object>> colision(ColisionReservaException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("timestamp", LocalDateTime.now(), "status", 409, "error", e.getMessage()));
    }
    @ExceptionHandler(DocumentoVencidoException.class)
    public ResponseEntity<Map<String, Object>> docVencido(DocumentoVencidoException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("timestamp", LocalDateTime.now(), "status", 403, "error", e.getMessage()));
    }
    @ExceptionHandler(FraudeHorometroException.class)
    public ResponseEntity<Map<String, Object>> fraude(FraudeHorometroException e) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("timestamp", LocalDateTime.now(), "status", 400, "error", e.getMessage()));
    }
    @ExceptionHandler(CredencialesInvalidasException.class)
    public ResponseEntity<Map<String, Object>> credenciales(CredencialesInvalidasException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("timestamp", LocalDateTime.now(), "status", 401, "error", e.getMessage()));
    }
}
'@

# ================= DTOs =================
W "dto\ReservaRequest.java" @'
package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;
@Data
public class ReservaRequest {
    @NotNull private Integer idItemContrato;
    @NotNull private LocalDate fechaInicio;
    @NotNull private LocalDate fechaFin;
}
'@
W "dto\CheckOutRequest.java" @'
package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
@Data
public class CheckOutRequest {
    @NotNull private Integer idReserva;
    @NotNull private BigDecimal horometroInicial;
}
'@
W "dto\CheckInRequest.java" @'
package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
@Data
public class CheckInRequest {
    @NotNull private Integer idSalida;
    @NotNull private BigDecimal horometroFinal;
}
'@

# ================= SERVICIOS (Logica de Negocio Seccion 2.5.1) =================
W "service\ReservaService.java" @'
package pe.valhala.backend.service;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.valhala.backend.dto.ReservaRequest;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.exception.ColisionReservaException;
import pe.valhala.backend.repository.ItemContratoRepository;
import pe.valhala.backend.repository.ReservaGanttRepository;
import java.util.List;

@Service
public class ReservaService {
    private final ReservaGanttRepository reservaRepo;
    private final ItemContratoRepository itemRepo;

    public ReservaService(ReservaGanttRepository reservaRepo, ItemContratoRepository itemRepo) {
        this.reservaRepo = reservaRepo;
        this.itemRepo = itemRepo;
    }

    @Transactional
    public ReservaGantt crear(ReservaRequest req) {
        long colisiones = reservaRepo.contarColisiones(req.getIdItemContrato(), req.getFechaInicio(), req.getFechaFin());
        if (colisiones > 0) throw new ColisionReservaException();
        
        ItemContrato item = itemRepo.findById(req.getIdItemContrato()).orElseThrow();
        ReservaGantt r = new ReservaGantt();
        r.setItemContrato(item);
        r.setFechaInicioReserva(req.getFechaInicio());
        r.setFechaFinReserva(req.getFechaFin());
        r.setEstadoReserva("CONFIRMADA");
        return reservaRepo.save(r);
    }

    public List<ReservaGantt> listarGantt() {
        return reservaRepo.findByEstadoReservaInOrderByFechaInicioReserva(List.of("PENDIENTE", "CONFIRMADA"));
    }
}
'@

W "service\CheckOutService.java" @'
package pe.valhala.backend.service;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.valhala.backend.dto.CheckOutRequest;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.entity.DocumentoLegal;
import pe.valhala.backend.entity.EstadoActualEquipo;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.exception.DocumentoVencidoException;
import pe.valhala.backend.repository.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class CheckOutService {
    private final CheckOutSalidaRepository salidaRepo;
    private final ReservaGanttRepository reservaRepo;
    private final DocumentoLegalRepository docRepo;
    private final EstadoActualEquipoRepository estadoRepo;
    private final UsuarioRepository usuarioRepo;

    public CheckOutService(CheckOutSalidaRepository salidaRepo, ReservaGanttRepository reservaRepo, 
                           DocumentoLegalRepository docRepo, EstadoActualEquipoRepository estadoRepo, UsuarioRepository usuarioRepo) {
        this.salidaRepo = salidaRepo;
        this.reservaRepo = reservaRepo;
        this.docRepo = docRepo;
        this.estadoRepo = estadoRepo;
        this.usuarioRepo = usuarioRepo;
    }

    @Transactional
    public CheckOutSalida despachar(CheckOutRequest req, Integer idMecanico) {
        ReservaGantt reserva = reservaRepo.findById(req.getIdReserva()).orElseThrow();
        Integer idEquipo = reserva.getItemContrato().getEquipo().getIdEquipo();
        
        // RF-06: Validacion Legal
        List<DocumentoLegal> docs = docRepo.findByEquipoIdEquipo(idEquipo);
        boolean vencido = docs.stream().anyMatch(d -> d.getFechaVencimiento().isBefore(LocalDate.now()));
        if (vencido) throw new DocumentoVencidoException();

        Usuario mecanico = usuarioRepo.findById(idMecanico).orElseThrow();
        
        CheckOutSalida salida = new CheckOutSalida();
        salida.setReserva(reserva);
        salida.setUsuarioMecanico(mecanico);
        salida.setFechaDespacho(LocalDateTime.now());
        salida.setHorometroInicial(req.getHorometroInicial());
        
        // Actualizar estado a ALQUILADO
        EstadoActualEquipo estado = estadoRepo.findByEquipoIdEquipo(idEquipo).orElseThrow();
        estado.setEstatusOperativo("ALQUILADO");
        estadoRepo.save(estado);
        
        return salidaRepo.save(salida);
    }
}
'@

W "service\CheckInService.java" @'
package pe.valhala.backend.service;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.valhala.backend.dto.CheckInRequest;
import pe.valhala.backend.entity.CheckInRetorno;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.entity.EstadoActualEquipo;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.exception.FraudeHorometroException;
import pe.valhala.backend.repository.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;

@Service
public class CheckInService {
    private final CheckInRetornoRepository retornoRepo;
    private final CheckOutSalidaRepository salidaRepo;
    private final LiquidacionFinancieraRepository liquidacionRepo;
    private final EstadoActualEquipoRepository estadoRepo;
    private final UsuarioRepository usuarioRepo;

    public CheckInService(CheckInRetornoRepository retornoRepo, CheckOutSalidaRepository salidaRepo,
                          LiquidacionFinancieraRepository liquidacionRepo, EstadoActualEquipoRepository estadoRepo, UsuarioRepository usuarioRepo) {
        this.retornoRepo = retornoRepo;
        this.salidaRepo = salidaRepo;
        this.liquidacionRepo = liquidacionRepo;
        this.estadoRepo = estadoRepo;
        this.usuarioRepo = usuarioRepo;
    }

    @Transactional
    public LiquidacionFinanciera retornar(CheckInRequest req, Integer idMecanico) {
        CheckOutSalida salida = salidaRepo.findById(req.getIdSalida()).orElseThrow();
        
        // RF-05: Anti-fraude de horometro
        if (req.getHorometroFinal().compareTo(salida.getHorometroInicial()) < 0) {
            throw new FraudeHorometroException();
        }

        Usuario mecanico = usuarioRepo.findById(idMecanico).orElseThrow();
        
        CheckInRetorno retorno = new CheckInRetorno();
        retorno.setSalida(salida);
        retorno.setUsuarioMecanico(mecanico);
        retorno.setFechaRecepcion(LocalDateTime.now());
        retorno.setHorometroFinal(req.getHorometroFinal());
        retorno.setEstadoDevolucion("CONFORME");
        retornoRepo.save(retorno);

        // RF-05: Liquidacion Matematica
        ItemContrato item = salida.getReserva().getItemContrato();
        BigDecimal horasReales = req.getHorometroFinal().subtract(salida.getHorometroInicial());
        BigDecimal horasBase = horasReales.min(item.getHorasMinimasGarantizadas());
        BigDecimal horasExtra = horasReales.subtract(horasBase).max(BigDecimal.ZERO);
        
        BigDecimal subtotal = (horasBase.multiply(item.getTarifaPorHora())).add(horasExtra.multiply(item.getTarifaPorHora()).multiply(new BigDecimal("1.5")));
        subtotal = subtotal.add(item.getCostoFlete()).setScale(2, RoundingMode.HALF_UP);
        BigDecimal igv = subtotal.multiply(new BigDecimal("0.18")).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(igv);

        LiquidacionFinanciera liq = new LiquidacionFinanciera();
        liq.setRetorno(retorno);
        liq.setHorasBaseConsumidas(horasBase);
        liq.setHorasExtraCalculadas(horasExtra);
        liq.setSubtotal(subtotal);
        liq.setIgv(igv);
        liq.setTotalFacturar(total);
        liq.setEstadoCobro("PENDIENTE");
        liquidacionRepo.save(liq);

        // Regresar estado a OPERATIVO
        EstadoActualEquipo estado = estadoRepo.findByEquipoIdEquipo(salida.getReserva().getItemContrato().getEquipo().getIdEquipo()).orElseThrow();
        estado.setEstatusOperativo("OPERATIVO");
        estadoRepo.save(estado);

        return liq;
    }
}
'@

# ================= CONTROLADORES =================
W "controller\ReservaController.java" @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.ReservaRequest;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.service.ReservaService;
import java.util.List;

@RestController
@RequestMapping("/api/v1/reservas")
public class ReservaController {
    private final ReservaService service;
    public ReservaController(ReservaService service) { this.service = service; }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ReservaGantt> crear(@Valid @RequestBody ReservaRequest req) {
        return ResponseEntity.ok(service.crear(req));
    }

    @GetMapping("/gantt")
    @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<ReservaGantt> gantt() { return service.listarGantt(); }
}
'@

W "controller\CheckOutController.java" @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.CheckOutRequest;
import pe.valhala.backend.entity.CheckOutSalida;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.service.CheckOutService;

@RestController
@RequestMapping("/api/v1/transacciones/checkout")
public class CheckOutController {
    private final CheckOutService service;
    private final UsuarioRepository usuarioRepo;
    public CheckOutController(CheckOutService service, UsuarioRepository usuarioRepo) {
        this.service = service;
        this.usuarioRepo = usuarioRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<CheckOutSalida> despachar(@Valid @RequestBody CheckOutRequest req, @AuthenticationPrincipal UserDetails user) {
        // En nuestro filtro JWT, el subject es el email
        Integer idMecanico = usuarioRepo.findByEmail(user.getUsername()).orElseThrow().getIdUsuario();
        return ResponseEntity.ok(service.despachar(req, idMecanico));
    }
}
'@

W "controller\CheckInController.java" @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.CheckInRequest;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.service.CheckInService;

@RestController
@RequestMapping("/api/v1/transacciones/checkin")
public class CheckInController {
    private final CheckInService service;
    private final UsuarioRepository usuarioRepo;
    public CheckInController(CheckInService service, UsuarioRepository usuarioRepo) {
        this.service = service;
        this.usuarioRepo = usuarioRepo;
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<LiquidacionFinanciera> retornar(@Valid @RequestBody CheckInRequest req, @AuthenticationPrincipal UserDetails user) {
        Integer idMecanico = usuarioRepo.findByEmail(user.getUsername()).orElseThrow().getIdUsuario();
        return ResponseEntity.ok(service.retornar(req, idMecanico));
    }
}
'@

Write-Host "FASE 6 (CORAZON DEL NEGOCIO) GENERADA!"