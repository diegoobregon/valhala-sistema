package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.ItemContrato;
import java.util.List;
public interface ItemContratoRepository extends JpaRepository<ItemContrato, Integer> {
    @Query("SELECT i FROM ItemContrato i WHERE i.contrato.empresa.idEmpresa = :idEmpresa")
    List<ItemContrato> findByIdEmpresa(@Param("idEmpresa") Integer idEmpresa);
}