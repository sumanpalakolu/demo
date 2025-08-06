package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController // Marks this class as a REST Controller
@RequestMapping("/names") // Base path for all endpoints in this controller
public class NameController {

    @Autowired // Injects the NameRepository
    private NameRepository nameRepository;

    @PostMapping // Handles POST requests to /names
    public NameEntity addName(@RequestBody String name) {
        NameEntity newName = new NameEntity(name);
        return nameRepository.save(newName); // Saves the new name to the database
    }

    @GetMapping // Handles GET requests to /names
    public List<NameEntity> getAllNames() {
        return nameRepository.findAll(); // Retrieves all names from the database
    }
}