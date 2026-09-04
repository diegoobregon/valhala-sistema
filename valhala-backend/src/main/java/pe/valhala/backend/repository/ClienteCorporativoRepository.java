package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import pe.valhala.backend.entity.ClienteCorporativo;
import java.util.List;
public interface ClienteCorporativoRepository extends JpaRepository<ClienteCorporativo, Integer> {
    @Query("SELECT c FROM ClienteCorporativo c WHERE c.empresa.idEmpresa = :idEmpresa")
    List<ClienteCorporativo> findByIdEmpresa(Integer idEmpresa);
}