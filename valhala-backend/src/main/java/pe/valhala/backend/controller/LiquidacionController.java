package pe.valhala.backend.controller;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.entity.LiquidacionFinanciera;
import pe.valhala.backend.repository.LiquidacionFinancieraRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.util.List;
@RestController
@RequestMapping("/api/v1/liquidaciones")
public class LiquidacionController {
    private final LiquidacionFinancieraRepository repo;
    private final UsuarioRepository usrRepo;
    public LiquidacionController(LiquidacionFinancieraRepository repo, UsuarioRepository usrRepo) { this.repo = repo; this.usrRepo = usrRepo; }
    private Integer empresaActual() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return usrRepo.findByEmail(email).map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
    }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<LiquidacionFinanciera> listar() {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) return repo.findByIdEmpresa(idEmpresa);
        return repo.findAll();
    }
}