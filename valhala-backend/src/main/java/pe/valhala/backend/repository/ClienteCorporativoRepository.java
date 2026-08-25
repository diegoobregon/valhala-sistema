package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.ClienteCorporativo;

public interface ClienteCorporativoRepository extends JpaRepository<ClienteCorporativo, Integer> {
}