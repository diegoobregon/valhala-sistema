package pe.valhala.backend.controller;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.repository.LiquidacionFinancieraRepository;
import java.util.List;

@RestController
@RequestMapping("/api/v1/liquidaciones")
public class LiquidacionController {
    private final LiquidacionFinancieraRepository repo;
    public LiquidacionController(LiquidacionFinancieraRepository repo) { this.repo = repo; }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<LiquidacionFinanciera> listar() { return repo.findAll(); }
}