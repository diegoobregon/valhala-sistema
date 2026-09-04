package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.MantenimientoTaller;
import java.util.List;
public interface MantenimientoTallerRepository extends JpaRepository<MantenimientoTaller, Integer> {
    @Query("SELECT m FROM MantenimientoTaller m WHERE m.equipo.empresa.idEmpresa = :idEmpresa")
    List<MantenimientoTaller> findByIdEmpresa(@Param("idEmpresa") Integer idEmpresa);
}