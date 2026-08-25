package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.ClienteCorporativo;
import pe.valhala.backend.repository.ClienteCorporativoRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/clientes")
public class ClienteController {
    private final ClienteCorporativoRepository repo;
    public ClienteController(ClienteCorporativoRepository repo) { this.repo = repo; }
    @Data public static class ClienteDTO { private String ruc; private String razonSocial; private String direccionFiscal; private String telefono; private String emailContacto; }
    @GetMapping @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<ClienteCorporativo> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ClienteCorporativo> crear(@RequestBody ClienteDTO d) {
        ClienteCorporativo c = new ClienteCorporativo();
        c.setRuc(d.getRuc()); c.setRazonSocial(d.getRazonSocial()); c.setDireccionFiscal(d.getDireccionFiscal());
        c.setTelefono(d.getTelefono()); c.setEmailContacto(d.getEmailContacto());
        return ResponseEntity.ok(repo.save(c));
    }
}