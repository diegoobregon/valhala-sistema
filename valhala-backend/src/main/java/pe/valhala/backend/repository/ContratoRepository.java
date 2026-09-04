package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import pe.valhala.backend.entity.Contrato;
import java.util.List;
public interface ContratoRepository extends JpaRepository<Contrato, Integer> {
    @Query("SELECT c FROM Contrato c WHERE c.empresa.idEmpresa = :idEmpresa")
    List<Contrato> findByIdEmpresa(Integer idEmpresa);
}