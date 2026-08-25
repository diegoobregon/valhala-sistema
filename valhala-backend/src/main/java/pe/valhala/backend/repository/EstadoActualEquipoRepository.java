package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.EstadoActualEquipo;

import java.util.Optional;

public interface EstadoActualEquipoRepository extends JpaRepository<EstadoActualEquipo, Integer> {
    Optional<EstadoActualEquipo> findByEquipoIdEquipo(Integer idEquipo);
}