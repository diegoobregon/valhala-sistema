package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.VerificacionEmail;
import java.util.Optional;
public interface VerificacionEmailRepository extends JpaRepository<VerificacionEmail, Integer> {
    Optional<VerificacionEmail> findByEmailAndCodigoAndUsadoFalse(String email, String codigo);
}