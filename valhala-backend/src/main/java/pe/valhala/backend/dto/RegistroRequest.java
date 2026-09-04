package pe.valhala.backend.dto;
import jakarta.validation.constraints.*;
import lombok.*;
@Data @NoArgsConstructor @AllArgsConstructor
public class RegistroRequest {
    @NotBlank @Pattern(regexp = "^\\d{11}$") private String ruc;
    @NotBlank private String razonSocial;
    @NotBlank @Email private String emailContacto;
    @NotBlank @Size(min = 6) private String password;
    @NotBlank private String nombresAdmin;
    @NotBlank private String apellidosAdmin;
    @NotBlank @Pattern(regexp = "^\\d{8}$") private String dniAdmin;
}