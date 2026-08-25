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