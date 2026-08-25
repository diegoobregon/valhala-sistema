$base = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\java\pe\valhala\backend"
$utf8 = New-Object System.Text.UTF8Encoding $false
function W($rel, $c) { [System.IO.File]::WriteAllText("$base\$rel", $c, $utf8); Write-Host "OK $rel" }

W "controller\EquipoController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.CategoriaLineaAmarrilla;
import pe.valhala.backend.entity.Equipo;
import pe.valhala.backend.repository.CategoriaLineaAmarrillaRepository;
import pe.valhala.backend.repository.EquipoRepository;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/equipos")
public class EquipoController {
    private final EquipoRepository equipoRepo;
    private final CategoriaLineaAmarrillaRepository catRepo;
    public EquipoController(EquipoRepository equipoRepo, CategoriaLineaAmarrillaRepository catRepo) { this.equipoRepo = equipoRepo; this.catRepo = catRepo; }

    @Data public static class EquipoDTO { private Integer idCategoria; private String codigoPatrimonial; private String marca; private String modelo; private Integer anioFabricacion; private BigDecimal horometroAcumulado; }

    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<Equipo> listar() { return equipoRepo.findAll(); }

    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Equipo> crear(@RequestBody EquipoDTO dto) { Equipo e = new Equipo(); aplicar(e, dto); return ResponseEntity.ok(equipoRepo.save(e)); }

    @PutMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Equipo> actualizar(@PathVariable Integer id, @RequestBody EquipoDTO dto) { Equipo e = equipoRepo.findById(id).orElseThrow(); aplicar(e, dto); return ResponseEntity.ok(equipoRepo.save(e)); }

    @DeleteMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> eliminar(@PathVariable Integer id) { equipoRepo.deleteById(id); return ResponseEntity.ok().build(); }

    private void aplicar(Equipo e, EquipoDTO dto) {
        e.setCategoria(catRepo.findById(dto.getIdCategoria()).orElseThrow());
        e.setCodigoPatrimonial(dto.getCodigoPatrimonial()); e.setMarca(dto.getMarca()); e.setModelo(dto.getModelo());
        e.setAnioFabricacion(dto.getAnioFabricacion()); e.setHorometroAcumulado(dto.getHorometroAcumulado());
    }
}
'@

W "controller\CategoriaController.java" @'
package pe.valhala.backend.controller;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.CategoriaLineaAmarrilla;
import pe.valhala.backend.repository.CategoriaLineaAmarrillaRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/categorias")
public class CategoriaController {
    private final CategoriaLineaAmarrillaRepository repo;
    public CategoriaController(CategoriaLineaAmarrillaRepository repo) { this.repo = repo; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<CategoriaLineaAmarrilla> listar() { return repo.findAll(); }
}
'@

W "controller\ClienteController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.ClienteCorporativo;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/clientes")
public class ClienteController {
    private final ClienteCorporativoRepository repo;
    public ClienteController(ClienteCorporativoRepository repo) { this.repo = repo; }
    @Data public static class ClienteDTO { private String ruc; private String razonSocial; private String direccionFiscal; private String telefono; private String emailContacto; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<ClienteCorporativo> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ClienteCorporativo> crear(@RequestBody ClienteDTO d) {
        ClienteCorporativo c = new ClienteCorporativo();
        c.setRuc(d.getRuc()); c.setRazonSocial(d.getRazonSocial()); c.setDireccionFiscal(d.getDireccionFiscal());
        c.setTelefono(d.getTelefono()); c.setEmailContacto(d.getEmailContacto());
        return ResponseEntity.ok(repo.save(c));
    }
}
'@

W "controller\UsuarioController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.repository.RolRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/usuarios")
public class UsuarioController {
    private final UsuarioRepository repo; private final RolRepository rolRepo; private final PasswordEncoder enc;
    public UsuarioController(UsuarioRepository repo, RolRepository rolRepo, PasswordEncoder enc) { this.repo = repo; this.rolRepo = rolRepo; this.enc = enc; }
    @Data public static class UsuarioDTO { private Integer idRol; private String dni; private String nombres; private String apellidos; private String email; private String password; }
    @GetMapping @PreAuthorize("hasRole('ADMIN')")
    public List<Usuario> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Usuario> crear(@RequestBody UsuarioDTO d) {
        Usuario u = new Usuario();
        u.setRol(rolRepo.findById(d.getIdRol()).orElseThrow());
        u.setDni(d.getDni()); u.setNombres(d.getNombres()); u.setApellidos(d.getApellidos()); u.setEmail(d.getEmail());
        u.setPasswordHash(enc.encode(d.getPassword())); u.setEstadoActivo(true);
        return ResponseEntity.ok(repo.save(u));
    }
}
'@

W "controller\ContratoController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Contrato;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import pe.valhala.backend.repository.ContratoRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.time.LocalDate;
import java.util.List;
@RestController @RequestMapping("/api/v1/contratos")
public class ContratoController {
    private final ContratoRepository repo; private final ClienteCorporativoRepository cliRepo; private final UsuarioRepository usrRepo;
    public ContratoController(ContratoRepository repo, ClienteCorporativoRepository cliRepo, UsuarioRepository usrRepo) { this.repo = repo; this.cliRepo = cliRepo; this.usrRepo = usrRepo; }
    @Data public static class ContratoDTO { private Integer idCliente; private LocalDate fechaInicio; private LocalDate fechaFin; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<Contrato> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Contrato> crear(@RequestBody ContratoDTO d) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Contrato c = new Contrato();
        c.setCliente(cliRepo.findById(d.getIdCliente()).orElseThrow());
        c.setUsuarioCreador(usrRepo.findByEmail(email).orElseThrow());
        c.setFechaEmision(LocalDate.now()); c.setFechaInicio(d.getFechaInicio()); c.setFechaFin(d.getFechaFin());
        c.setEstadoContrato("ACTIVO");
        return ResponseEntity.ok(repo.save(c));
    }
}
'@

W "controller\MantenimientoController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.MantenimientoTaller;
import pe.valhala.backend.repository.EquipoRepository;
import pe.valhala.backend.repository.MantenimientoTallerRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.math.BigDecimal;
import java.util.List;
@RestController @RequestMapping("/api/v1/mantenimientos")
public class MantenimientoController {
    private final MantenimientoTallerRepository repo; private final EquipoRepository eqRepo; private final UsuarioRepository usrRepo;
    public MantenimientoController(MantenimientoTallerRepository repo, EquipoRepository eqRepo, UsuarioRepository usrRepo) { this.repo = repo; this.eqRepo = eqRepo; this.usrRepo = usrRepo; }
    @Data public static class ManDTO { private Integer idEquipo; private String tipoMantenimiento; private BigDecimal horometroEjecucion; private BigDecimal costoReparacion; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<MantenimientoTaller> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public ResponseEntity<MantenimientoTaller> crear(@RequestBody ManDTO d) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        MantenimientoTaller m = new MantenimientoTaller();
        m.setEquipo(eqRepo.findById(d.getIdEquipo()).orElseThrow());
        m.setUsuarioMecanico(usrRepo.findByEmail(email).orElseThrow());
        m.setTipoMantenimiento(d.getTipoMantenimiento()); m.setHorometroEjecucion(d.getHorometroEjecucion()); m.setCostoReparacion(d.getCostoReparacion());
        return ResponseEntity.ok(repo.save(m));
    }
}
'@

W "controller\DocumentoLegalController.java" @'
package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.DocumentoLegal;
import pe.valhala.backend.repository.DocumentoLegalRepository;
import pe.valhala.backend.repository.EquipoRepository;
import java.time.LocalDate;
import java.util.List;
@RestController @RequestMapping("/api/v1/documentos")
public class DocumentoLegalController {
    private final DocumentoLegalRepository repo; private final EquipoRepository eqRepo;
    public DocumentoLegalController(DocumentoLegalRepository repo, EquipoRepository eqRepo) { this.repo = repo; this.eqRepo = eqRepo; }
    @Data public static class DocDTO { private Integer idEquipo; private String tipoPoliza; private String numeroPoliza; private LocalDate fechaVencimiento; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','MECANICO')")
    public List<DocumentoLegal> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DocumentoLegal> crear(@RequestBody DocDTO d) {
        DocumentoLegal doc = new DocumentoLegal();
        doc.setEquipo(eqRepo.findById(d.getIdEquipo()).orElseThrow());
        doc.setTipoPoliza(d.getTipoPoliza()); doc.setNumeroPoliza(d.getNumeroPoliza());
        doc.setFechaVencimiento(d.getFechaVencimiento()); doc.setEstadoLegal("VIGENTE");
        return ResponseEntity.ok(repo.save(doc));
    }
}
'@

W "controller\ReservaController.java" @'
package pe.valhala.backend.controller;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.dto.ReservaRequest;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.repository.ReservaGanttRepository;
import pe.valhala.backend.service.ReservaService;
import java.util.List;
@RestController @RequestMapping("/api/v1/reservas")
public class ReservaController {
    private final ReservaService service; private final ReservaGanttRepository repo;
    public ReservaController(ReservaService service, ReservaGanttRepository repo) { this.service = service; this.repo = repo; }
    @PostMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public ResponseEntity<ReservaGantt> crear(@Valid @RequestBody ReservaRequest req) { return ResponseEntity.ok(service.crear(req)); }
    @GetMapping("/gantt") @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<ReservaGantt> gantt() { return service.listarGantt(); }
    @DeleteMapping("/{id}") @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> anular(@PathVariable Integer id) {
        ReservaGantt r = repo.findById(id).orElseThrow(); r.setEstadoReserva("ANULADA"); repo.save(r);
        return ResponseEntity.ok().build();
    }
}
'@

Write-Host "PARCHE5 (CRUD COMPLETO) APLICADO! Reinicia el backend."