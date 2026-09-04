package pe.valhala.backend.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.DocumentoLegal;
import java.util.List;
public interface DocumentoLegalRepository extends JpaRepository<DocumentoLegal, Integer> {
    List<DocumentoLegal> findByEquipoIdEquipo(Integer idEquipo);
    @Query("SELECT d FROM DocumentoLegal d WHERE d.equipo.empresa.idEmpresa = :idEmpresa")
    List<DocumentoLegal> findByIdEmpresa(@Param("idEmpresa") Integer idEmpresa);
}