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