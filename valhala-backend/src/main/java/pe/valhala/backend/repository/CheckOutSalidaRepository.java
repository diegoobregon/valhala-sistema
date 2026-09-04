package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.CheckOutSalida;
import java.util.List;
public interface CheckOutSalidaRepository extends JpaRepository<CheckOutSalida, Integer> {
    @Query("SELECT s FROM CheckOutSalida s WHERE s.reserva.itemContrato.contrato.empresa.idEmpresa = :idEmpresa")
    List<CheckOutSalida> findByIdEmpresa(@Param("idEmpresa") Integer idEmpresa);
}