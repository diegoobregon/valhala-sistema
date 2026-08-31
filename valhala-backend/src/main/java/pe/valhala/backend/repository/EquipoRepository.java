package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import pe.valhala.backend.entity.Equipo;

import java.util.List;

public interface EquipoRepository extends JpaRepository<Equipo, Long> {
    @Query("select e from Equipo e join fetch e.categoria")
    List<Equipo> findAll();
}