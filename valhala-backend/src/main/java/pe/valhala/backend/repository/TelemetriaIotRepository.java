package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.TelemetriaIot;
import pe.valhala.backend.entity.TelemetriaIotId;

public interface TelemetriaIotRepository extends JpaRepository<TelemetriaIot, TelemetriaIotId> {
}