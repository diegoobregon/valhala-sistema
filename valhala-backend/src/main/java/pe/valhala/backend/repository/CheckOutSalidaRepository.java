package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.CheckOutSalida;

public interface CheckOutSalidaRepository extends JpaRepository<CheckOutSalida, Integer> {
}