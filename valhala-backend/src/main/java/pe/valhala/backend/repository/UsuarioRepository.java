package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Usuario;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByEmail(String email);
}