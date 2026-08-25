package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.ItemContrato;

public interface ItemContratoRepository extends JpaRepository<ItemContrato, Integer> {
}