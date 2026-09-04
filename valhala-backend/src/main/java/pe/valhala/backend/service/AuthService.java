package pe.valhala.backend.service;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import pe.valhala.backend.dto.LoginRequest;
import pe.valhala.backend.dto.LoginResponse;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.repository.UsuarioRepository;
import pe.valhala.backend.security.CredencialesInvalidasException;
import pe.valhala.backend.security.JwtService;
@Service
public class AuthService {
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    public AuthService(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.usuarioRepository = usuarioRepository; this.passwordEncoder = passwordEncoder; this.jwtService = jwtService;
    }
    public LoginResponse login(LoginRequest req) {
        Usuario u = usuarioRepository.findByEmail(req.getEmail())
                .filter(x -> Boolean.TRUE.equals(x.getEstadoActivo()))
                .orElseThrow(CredencialesInvalidasException::new);
        if (!passwordEncoder.matches(req.getPassword(), u.getPasswordHash())) { throw new CredencialesInvalidasException(); }
        String rol = u.getRol().getNombreRol();
        String nombres = u.getNombres() + " " + u.getApellidos();
        Integer idEmpresa = u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null;
        return new LoginResponse(jwtService.generarToken(u.getEmail(), rol, nombres, idEmpresa), rol, nombres);
    }
}