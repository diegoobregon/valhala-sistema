package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import java.util.List;
public interface LiquidacionFinancieraRepository extends JpaRepository<LiquidacionFinanciera, Integer> {
    @Query("SELECT l FROM LiquidacionFinanciera l WHERE l.retorno.salida.reserva.itemContrato.contrato.empresa.idEmpresa = :idEmpresa")
    List<LiquidacionFinanciera> findByIdEmpresa(@Param("idEmpresa") Integer idEmpresa);
}