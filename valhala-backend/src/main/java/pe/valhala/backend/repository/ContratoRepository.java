package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Contrato;

public interface ContratoRepository extends JpaRepository<Contrato, Integer> {
}