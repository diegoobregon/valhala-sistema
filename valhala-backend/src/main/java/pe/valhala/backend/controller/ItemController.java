package pe.valhala.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.valhala.backend.entity.ItemContrato;
import pe.valhala.backend.repository.ItemContratoRepository;

import java.util.List;

@RestController
@RequestMapping("/api/v1/items")
public class ItemController {

    private final ItemContratoRepository repo;

    public ItemController(ItemContratoRepository repo) { this.repo = repo; }

    @GetMapping
    public List<ItemContrato> listar() { return repo.findAll(); }
}