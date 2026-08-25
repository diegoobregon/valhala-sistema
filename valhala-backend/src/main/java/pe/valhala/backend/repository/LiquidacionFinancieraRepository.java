package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.LiquidacionFinanciera;

public interface LiquidacionFinancieraRepository extends JpaRepository<LiquidacionFinanciera, Integer> {
}