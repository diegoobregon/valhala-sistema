package pe.valhala.backend.service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.valhala.backend.dto.*;
import pe.valhala.backend.entity.Empresa;
import pe.valhala.backend.entity.Rol;
import pe.valhala.backend.entity.Usuario;
import pe.valhala.backend.entity.VerificacionEmail;
import pe.valhala.backend.exception.EmailNoVerificadoException;
import pe.valhala.backend.exception.EmpresaNoVerificadaException;
import pe.valhala.backend.repository.*;
import pe.valhala.backend.security.CredencialesInvalidasException;
import pe.valhala.backend.security.JwtService;
import java.time.LocalDateTime;
import java.util.Random;
@Service
public class AuthService {
    private static final Logger log = LoggerFactory.getLogger(AuthService.class);
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final EmpresaRepository empresaRepository;
    private final RolRepository rolRepository;
    private final VerificacionEmailRepository verificacionEmailRepository;
    public AuthService(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder, JwtService jwtService, EmpresaRepository empresaRepository, RolRepository rolRepository, VerificacionEmailRepository verificacionEmailRepository) {
        this.usuarioRepository = usuarioRepository; this.passwordEncoder = passwordEncoder; this.jwtService = jwtService;
        this.empresaRepository = empresaRepository; this.rolRepository = rolRepository; this.verificacionEmailRepository = verificacionEmailRepository;
    }
    public LoginResponse login(LoginRequest req) {
        Usuario u = usuarioRepository.findByEmail(req.getEmail())
                .filter(x -> Boolean.TRUE.equals(x.getEstadoActivo()))
                .orElseThrow(CredencialesInvalidasException::new);
        if (!passwordEncoder.matches(req.getPassword(), u.getPasswordHash())) { throw new CredencialesInvalidasException(); }
        if (u.getEmpresa() != null && !"ACTIVO".equals(u.getEmpresa().getEstado())) { throw new EmpresaNoVerificadaException(); }
        String rol = u.getRol().getNombreRol();
        String nombres = u.getNombres() + " " + u.getApellidos();
        Integer idEmpresa = u.getEmpresa() != null ? u.getEmpresa().getIdEmpresa() : null;
        return new LoginResponse(jwtService.generarToken(u.getEmail(), rol, nombres, idEmpresa), rol, nombres);
    }
    @Transactional
    public RegistroResponse registrar(RegistroRequest req) {
        if (empresaRepository.findByRuc(req.getRuc()).isPresent()) { throw new RuntimeException("El RUC ya está registrado"); }
        if (usuarioRepository.findByEmail(req.getEmailContacto()).isPresent()) { throw new RuntimeException("El email ya está registrado"); }
        Empresa empresa = new Empresa();
        empresa.setRuc(req.getRuc()); empresa.setRazonSocial(req.getRazonSocial());
        empresa.setEmailContacto(req.getEmailContacto()); empresa.setEstado("PENDIENTE");
        empresa.setFechaRegistro(LocalDateTime.now());
        empresa = empresaRepository.save(empresa);
        Rol rolAdmin = rolRepository.findByNombreRol("ADMIN").orElseThrow(() -> new RuntimeException("Rol ADMIN no encontrado"));
        Usuario usuario = new Usuario();
        usuario.setDni(req.getDniAdmin()); usuario.setNombres(req.getNombresAdmin()); usuario.setApellidos(req.getApellidosAdmin());
        usuario.setEmail(req.getEmailContacto()); usuario.setPasswordHash(passwordEncoder.encode(req.getPassword()));
        usuario.setRol(rolAdmin); usuario.setEstadoActivo(true); usuario.setEmpresa(empresa);
        usuarioRepository.save(usuario);
        String codigo = String.valueOf(100000 + new Random().nextInt(900000));
        VerificacionEmail v = new VerificacionEmail();
        v.setEmail(req.getEmailContacto()); v.setCodigo(codigo); v.setCreadoEn(LocalDateTime.now()); v.setUsado(false);
        verificacionEmailRepository.save(v);
        log.info("CÓDIGO DE VERIFICACIÓN PARA {}: {}", req.getEmailContacto(), codigo);
        return new RegistroResponse("Empresa creada. Verifica tu correo con el código enviado.", empresa.getIdEmpresa(), req.getEmailContacto());
    }
    @Transactional
    public VerificarResponse verificar(VerificarRequest req) {
        VerificacionEmail v = verificacionEmailRepository.findByEmailAndCodigoAndUsadoFalse(req.getEmail(), req.getCodigo())
                .orElseThrow(EmailNoVerificadoException::new);
        v.setUsado(true); verificacionEmailRepository.save(v);
        Empresa empresa = empresaRepository.findByEmailContacto(req.getEmail()).orElseThrow(() -> new RuntimeException("Empresa no encontrada"));
        empresa.setEstado("ACTIVO"); empresaRepository.save(empresa);
        return new VerificarResponse(true, "Empresa verificada exitosamente");
    }
}
