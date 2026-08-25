$base = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\java\pe\valhala\backend"
$utf8 = New-Object System.Text.UTF8Encoding $false
function W($rel, $content) {
    $path = Join-Path $base $rel
    $dir = Split-Path $path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [System.IO.File]::WriteAllText($path, $content, $utf8)
    Write-Host "OK $rel"
}

# ================= REPOSITORIOS (16) =================
W "repository\RolRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Rol;

public interface RolRepository extends JpaRepository<Rol, Integer> {
}
'@

W "repository\UsuarioRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Usuario;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByEmail(String email);
}
'@

W "repository\ClienteCorporativoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.ClienteCorporativo;

public interface ClienteCorporativoRepository extends JpaRepository<ClienteCorporativo, Integer> {
}
'@

W "repository\ContratoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Contrato;

public interface ContratoRepository extends JpaRepository<Contrato, Integer> {
}
'@

W "repository\CategoriaLineaAmarrillaRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.CategoriaLineaAmarrilla;

public interface CategoriaLineaAmarrillaRepository extends JpaRepository<CategoriaLineaAmarrilla, Integer> {
}
'@

W "repository\EquipoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.Equipo;

public interface EquipoRepository extends JpaRepository<Equipo, Integer> {
}
'@

W "repository\DocumentoLegalRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.DocumentoLegal;

import java.util.List;

public interface DocumentoLegalRepository extends JpaRepository<DocumentoLegal, Integer> {
    List<DocumentoLegal> findByEquipoIdEquipo(Integer idEquipo);
}
'@

W "repository\EstadoActualEquipoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.EstadoActualEquipo;

import java.util.Optional;

public interface EstadoActualEquipoRepository extends JpaRepository<EstadoActualEquipo, Integer> {
    Optional<EstadoActualEquipo> findByEquipoIdEquipo(Integer idEquipo);
}
'@

W "repository\ItemContratoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.ItemContrato;

public interface ItemContratoRepository extends JpaRepository<ItemContrato, Integer> {
}
'@

W "repository\ReservaGanttRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.valhala.backend.entity.ReservaGantt;

import java.time.LocalDate;
import java.util.List;

public interface ReservaGanttRepository extends JpaRepository<ReservaGantt, Integer> {

    @Query("SELECT COUNT(r) FROM ReservaGantt r WHERE r.itemContrato.idItem = :idItem " +
           "AND r.estadoReserva <> 'ANULADA' " +
           "AND r.fechaInicioReserva <= :fin AND r.fechaFinReserva >= :inicio")
    long contarColisiones(@Param("idItem") Integer idItem,
                          @Param("inicio") LocalDate inicio,
                          @Param("fin") LocalDate fin);

    List<ReservaGantt> findByEstadoReservaInOrderByFechaInicioReserva(List<String> estados);
}
'@

W "repository\CheckOutSalidaRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.CheckOutSalida;

public interface CheckOutSalidaRepository extends JpaRepository<CheckOutSalida, Integer> {
}
'@

W "repository\CheckInRetornoRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.CheckInRetorno;

public interface CheckInRetornoRepository extends JpaRepository<CheckInRetorno, Integer> {
}
'@

W "repository\InspeccionPwaRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.InspeccionPwa;

public interface InspeccionPwaRepository extends JpaRepository<InspeccionPwa, Integer> {
}
'@

W "repository\LiquidacionFinancieraRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.LiquidacionFinanciera;

public interface LiquidacionFinancieraRepository extends JpaRepository<LiquidacionFinanciera, Integer> {
}
'@

W "repository\MantenimientoTallerRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.MantenimientoTaller;

public interface MantenimientoTallerRepository extends JpaRepository<MantenimientoTaller, Integer> {
}
'@

W "repository\TelemetriaIotRepository.java" @'
package pe.valhala.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.valhala.backend.entity.TelemetriaIot;
import pe.valhala.backend.entity.TelemetriaIotId;

public interface TelemetriaIotRepository extends JpaRepository<TelemetriaIot, TelemetriaIotId> {
}
'@

# ================= SEGURIDAD JWT =================
W "security\CredencialesInvalidasException.java" @'
package pe.valhala.backend.security;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.UNAUTHORIZED)
public class CredencialesInvalidasException extends RuntimeException {
    public CredencialesInvalidasException() {
        super("Credenciales invalidas");
    }
}
'@

W "security\JwtService.java" @'
package pe.valhala.backend.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration-ms}")
    private long expirationMs;

    private SecretKey key() {
        return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    public String generarToken(String email, String rol, String nombres) {
        return Jwts.builder()
                .subject(email)
                .claim("rol", rol)
                .claim("nombres", nombres)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(key())
                .compact();
    }

    public Claims parsear(String token) {
        return Jwts.parser().verifyWith(key()).build().parseSignedClaims(token).getPayload();
    }

    public boolean esValido(String token) {
        try {
            parsear(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
'@

W "security\JwtAuthenticationFilter.java" @'
package pe.valhala.backend.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtAuthenticationFilter(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            String token = header.substring(7);
            if (jwtService.esValido(token) && SecurityContextHolder.getContext().getAuthentication() == null) {
                var claims = jwtService.parsear(token);
                String rol = claims.get("rol", String.class);
                var auth = new UsernamePasswordAuthenticationToken(
                        claims.getSubject(), null,
                        List.of(new SimpleGrantedAuthority("ROLE_" + rol)));
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        chain.doFilter(request, response);
    }
}
'@

# ================= CONFIG =================
W "config\SecurityConfig.java" @'
package pe.valhala.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import pe.valhala.backend.security.JwtAuthenticationFilter;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()
                .anyRequest().authenticated())
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration cfg = new CorsConfiguration();
        cfg.setAllowedOrigins(List.of("http://localhost:4200"));
        cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        cfg.setAllowedHeaders(List.of("*"));
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", cfg);
        return source;
    }
}
'@

# ================= DTOs =================
W "dto\LoginRequest.java" @'
package pe.valhala.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor
public class LoginRequest {
    @NotBlank @Email private String email;
    @NotBlank private String password;
}
'@

W "dto\LoginResponse.java" @'
package pe.valhala.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor
public class LoginResponse {
    private String token;
    private String rol;
    private String nombres;
}
'@

# ================= SERVICIO =================
W "service\AuthService.java" @'
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
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public LoginResponse login(LoginRequest req) {
        Usuario u = usuarioRepository.findByEmail(req.getEmail())
                .filter(x -> Boolean.TRUE.equals(x.getEstadoActivo()))
                .orElseThrow(CredencialesInvalidasException::new);
        if (!passwordEncoder.matches(req.getPassword(), u.getPasswordHash())) {
            throw new CredencialesInvalidasException();
        }
        String rol = u.getRol().getNombreRol();
        String nombres = u.getNombres() + " " + u.getApellidos();
        return new LoginResponse(jwtService.generarToken(u.getEmail(), rol, nombres), rol, nombres);
    }
}
'@

# ================= CONTROLADORES =================
W "controller\AuthController.java" @'
package pe.valhala.backend.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.dto.LoginRequest;
import pe.valhala.backend.dto.LoginResponse;
import pe.valhala.backend.service.AuthService;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
}
'@

W "controller\EquipoController.java" @'
package pe.valhala.backend.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.entity.Equipo;
import pe.valhala.backend.repository.EquipoRepository;

import java.util.List;

@RestController
@RequestMapping("/api/v1/equipos")
public class EquipoController {

    private final EquipoRepository equipoRepository;

    public EquipoController(EquipoRepository equipoRepository) {
        this.equipoRepository = equipoRepository;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','CLIENTE')")
    public List<Equipo> listar() {
        return equipoRepository.findAll();
    }
}
'@

# ================= POM: agrega jjwt =================
$pomPath = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\pom.xml"
$pom = [System.IO.File]::ReadAllText($pomPath)
if ($pom -notmatch 'jjwt-api') {
    $deps = @'
    <dependency>
      <groupId>io.jsonwebtoken</groupId>
      <artifactId>jjwt-api</artifactId>
      <version>0.12.6</version>
    </dependency>
    <dependency>
      <groupId>io.jsonwebtoken</groupId>
      <artifactId>jjwt-impl</artifactId>
      <version>0.12.6</version>
      <scope>runtime</scope>
    </dependency>
    <dependency>
      <groupId>io.jsonwebtoken</groupId>
      <artifactId>jjwt-jackson</artifactId>
      <version>0.12.6</version>
      <scope>runtime</scope>
    </dependency>
  </dependencies>
'@
    $pom = $pom.Replace("</dependencies>", $deps)
    [System.IO.File]::WriteAllText($pomPath, $pom, $utf8)
    Write-Host "OK pom.xml (jjwt)"
}

# ================= PROPERTIES: agrega JWT =================
$propsPath = "D:\ciclo 8\exp4\PROYECTO VALHALA\valhala-backend\src\main\resources\application.properties"
$txt = [System.IO.File]::ReadAllText($propsPath)
if ($txt -notmatch 'jwt.secret') {
    $jwt = @"

# ===== JWT (RNF-05) =====
jwt.secret=VALHALA_SAC_SUPER_SECRETO_JWT_2026_LINEA_AMARILLA_FLOTA_GPS
jwt.expiration-ms=86400000
"@
    [System.IO.File]::WriteAllText($propsPath, $txt + $jwt, $utf8)
    Write-Host "OK application.properties (jwt)"
}

Write-Host "FASE 5 GENERADA!"