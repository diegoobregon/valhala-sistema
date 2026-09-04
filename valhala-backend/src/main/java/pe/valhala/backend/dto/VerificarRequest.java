package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
@Data @NoArgsConstructor @AllArgsConstructor
public class VerificarRequest { @NotBlank private String email; @NotBlank private String codigo; }