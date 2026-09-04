package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.ClienteCorporativo;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import pe.valhala.backend.repository.EmpresaRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/clientes")
public class ClienteController {
    private final ClienteCorporativoRepository repo;
    private final UsuarioRepository usrRepo;
    private final EmpresaRepository empRepo;
    public ClienteController(ClienteCorporativoRepository repo, UsuarioRepository usrRepo, EmpresaRepository empRepo) { this.repo = repo; this.usrRepo = usrRepo; this.empRepo = empRepo; }
    @Data public static class ClienteDTO { private String ruc; private String razonSocial; private String direccionFiscal; private String telefono; private String emailContacto; }
    private Integer empresaActual() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return usrRepo.findByEmail(email).map(u -> u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null).orElse(null);
    }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<ClienteCorporativo> listar() {
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) return repo.findByIdEmpresa(idEmpresa);
        return repo.findAll();
    }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ClienteCorporativo> crear(@RequestBody ClienteDTO d) {
        ClienteCorporativo c = new ClienteCorporativo();
        c.setRuc(d.getRuc()); c.setRazonSocial(d.getRazonSocial()); c.setDireccionFiscal(d.getDireccionFiscal());
        c.setTelefono(d.getTelefono()); c.setEmailContacto(d.getEmailContacto());
        Integer idEmpresa = empresaActual();
        if (idEmpresa != null) c.setEmpresa(empRepo.findById(idEmpresa).orElse(null));
        return ResponseEntity.ok(repo.save(c));
    }
}