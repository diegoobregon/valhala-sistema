package pe.valhala.backend.controller;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.CategoriaLineaAmarrilla;
import pe.valhala.backend.repository.CategoriaLineaAmarrillaRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/categorias")
public class CategoriaController {
    private final CategoriaLineaAmarrillaRepository repo;
    public CategoriaController(CategoriaLineaAmarrillaRepository repo) { this.repo = repo; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE','MECANICO')")
    public List<CategoriaLineaAmarrilla> listar() { return repo.findAll(); }
}