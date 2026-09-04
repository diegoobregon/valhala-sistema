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
    @Value("${jwt.secret}") private String secret;
    @Value("${jwt.expiration-ms}") private long expirationMs;
    private SecretKey key() { return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8)); }
    public String generarToken(String email, String rol, String nombres, Integer idEmpresa) {
        return Jwts.builder()
                .subject(email)
                .claim("rol", rol)
                .claim("nombres", nombres)
                .claim("idEmpresa", idEmpresa)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(key())
                .compact();
    }
    public String generarToken(String email, String rol, String nombres) { return generarToken(email, rol, nombres, null); }
    public Claims parsear(String token) { return Jwts.parser().verifyWith(key()).build().parseSignedClaims(token).getPayload(); }
    public boolean esValido(String token) { try { parsear(token); return true; } catch (Exception e) { return false; } }
}