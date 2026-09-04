package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Empresa;
import java.util.Optional;
public interface EmpresaRepository extends JpaRepository<Empresa, Integer> {
    Optional<Empresa> findByRuc(String ruc);
}