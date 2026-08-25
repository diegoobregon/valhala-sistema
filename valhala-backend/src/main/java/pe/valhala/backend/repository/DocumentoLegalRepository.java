package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.DocumentoLegal;

import java.util.List;

public interface DocumentoLegalRepository extends JpaRepository<DocumentoLegal, Integer> {
    List<DocumentoLegal> findByEquipoIdEquipo(Integer idEquipo);
}