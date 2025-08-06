package com.example.demo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
// JpaRepository provides CRUD operations for NameEntity
@Repository
public interface NameRepository extends JpaRepository<NameEntity, Long> {
}