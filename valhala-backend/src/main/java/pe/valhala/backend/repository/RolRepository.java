package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Rol;

public interface RolRepository extends JpaRepository<Rol, Integer> {
}