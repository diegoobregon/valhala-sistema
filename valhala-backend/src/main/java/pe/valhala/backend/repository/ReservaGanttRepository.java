package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.ReservaGantt;

import java.time.LocalDate;
import java.util.List;

public interface ReservaGanttRepository extends JpaRepository<ReservaGantt, Integer> {

    @Query("SELECT COUNT(r) FROM ReservaGantt r WHERE r.itemContrato.idItem = :idItem " +
           "AND r.estadoReserva <> 'ANULADA' " +
           "AND r.fechaInicioReserva <= :fin AND r.fechaFinReserva >= :inicio")
    long contarColisiones(@Param("idItem") Integer idItem,
                          @Param("inicio") LocalDate inicio,
                          @Param("fin") LocalDate fin);

    List<ReservaGantt> findByEstadoReservaInOrderByFechaInicioReserva(List<String> estados);
}