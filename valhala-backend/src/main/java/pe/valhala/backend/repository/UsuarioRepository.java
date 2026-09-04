package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import pe.valhala.backend.entity.Usuario;
import java.util.List;
import java.util.Optional;
public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByEmail(String email);
    @Query("SELECT u FROM Usuario u WHERE u.empresa.idEmpresa = :idEmpresa")
    List<Usuario> findByIdEmpresa(Integer idEmpresa);
}