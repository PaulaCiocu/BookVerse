package com.licenta.bookverse.repository;

import com.licenta.bookverse.entity.Achievement;
import com.licenta.bookverse.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
import java.util.UUID;

public interface AchievementRepository extends JpaRepository<Achievement, Long> {

    Optional<Achievement> findByPerson(Person person);

    Optional<Achievement> findByPerson_Id(UUID personId);
}
