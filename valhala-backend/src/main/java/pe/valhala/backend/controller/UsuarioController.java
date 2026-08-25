package pe.valhala.backend.controller;
import lombok.Data;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.repository.RolRepository;
import pe.valhala.backend.repository.UsuarioRepository;
import java.util.List;
@RestController @RequestMapping("/api/v1/usuarios")
public class UsuarioController {
    private final UsuarioRepository repo; private final RolRepository rolRepo; private final PasswordEncoder enc;
    public UsuarioController(UsuarioRepository repo, RolRepository rolRepo, PasswordEncoder enc) { this.repo = repo; this.rolRepo = rolRepo; this.enc = enc; }
    @Data public static class UsuarioDTO { private Integer idRol; private String dni; private String nombres; private String apellidos; private String email; private String password; }
    @GetMapping @PreAuthorize("hasRole('ADMIN')")
    public List<Usuario> listar() { return repo.findAll(); }
    @PostMapping @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Usuario> crear(@RequestBody UsuarioDTO d) {
        Usuario u = new Usuario();
        u.setRol(rolRepo.findById(d.getIdRol()).orElseThrow());
        u.setDni(d.getDni()); u.setNombres(d.getNombres()); u.setApellidos(d.getApellidos()); u.setEmail(d.getEmail());
        u.setPasswordHash(enc.encode(d.getPassword())); u.setEstadoActivo(true);
        return ResponseEntity.ok(repo.save(u));
    }
}