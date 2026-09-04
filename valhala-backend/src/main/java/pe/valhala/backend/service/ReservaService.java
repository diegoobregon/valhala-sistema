package pe.valhala.backend.service;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import pe.valhala.backend.dto.ReservaRequest;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.entity.ReservaGantt;
import pe.valhala.backend.exception.ColisionReservaException;
import pe.valhala.backend.repository.ItemContratoRepository;
import pe.valhala.backend.repository.ReservaGanttRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.util.List;
@Service
public class ReservaService {
    private final ReservaGanttRepository reservaRepo;
    private final ItemContratoRepository itemRepo;
    private final UsuarioRepository usrRepo;
    public ReservaService(ReservaGanttRepository reservaRepo, ItemContratoRepository itemRepo, UsuarioRepository usrRepo) {
        this.reservaRepo = reservaRepo; this.itemRepo = itemRepo; this.usrRepo = usrRepo;
    }
    @Transactional
    public ReservaGantt crear(ReservaRequest req) {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Integer idEmpresaUsuario = usrRepo.findByEmail(email)
            .map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
        ItemContrato item = itemRepo.findById(req.getIdItemContrato()).orElseThrow();
        Integer idEmpresaItem = item.getContrato().getEmpresa() != null ? item.getContrato().getEmpresa().getIdEmpresa() : null;
        if (idEmpresaUsuario != null && !idEmpresaUsuario.equals(idEmpresaItem)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "El item no pertenece a su empresa");
        }
        long colisiones = reservaRepo.contarColisiones(req.getIdItemContrato(), req.getFechaInicio(), req.getFechaFin());
        if (colisiones > 0) throw new ColisionReservaException();
        ReservaGantt r = new ReservaGantt();
        r.setItemContrato(item);
        r.setFechaInicioReserva(req.getFechaInicio());
        r.setFechaFinReserva(req.getFechaFin());
        r.setEstadoReserva("CONFIRMADA");
        return reservaRepo.save(r);
    }
    public List<ReservaGantt> listarGantt(Integer idEmpresa) {
        if (idEmpresa != null) return reservaRepo.findByIdEmpresa(idEmpresa);
        return reservaRepo.findByEstadoReservaInOrderByFechaInicioReserva(List.of("PENDIENTE", "CONFIRMADA"));
    }
}