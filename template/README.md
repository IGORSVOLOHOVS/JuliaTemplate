# Introduction

# Chapter 1. Theoretical Background (skip theory)

# Chapter 2. Problem Domain Analysis and Problem Statement

## 2.1. Analysis of Existing Systems
References


## 2.2. Business Requirements
### 2.2.1. Goal

## 2.3. Functional Requirements
### 2.3.1. Use Case (not implemented)

## 2.4. Non-Functional Requirements
| Name            | 0% | 20% | 40% | 60% | 80% | 100% |
| :-------------- | :-: | :-: | :-: | :-: | :-: | :-: |
| **Performance** (Производительность)| x | - | - | - | - | - |
| **Security** (Безопасность) | x | - | - | - | - | - |
| **Usability** (Удобство использования)| x | - | - | - | - | - |
| **Reliability** (Надежность) | x | - | - | - | - | - |
| **Maintainability** (Поддерживаемость) | x | - | - | - | - | - |
| **Portability** (Переносимость) | x | - | - | - | - | - |
| **Supportability** (Возможность поддержки) | x | - | - | - | - | - |
| **Time to Market** (Скорость разработки) | - | - | - | - | - | x |

| Service       | No | Yes  |
| :------------ | :--: | :--: |
| Logic         | - | x |
| Test          | x | - |
| Coverage      | x | - |
| Profiler      | x | - |
| Logger        | x | - |
| Builder       | x | - |
| Database      | x | - |
| Configuration | x | - |
| Documentation | x | - |

# Chapter 3. Design and Implementation

## 3.1. Technology Stack Selection
* Julia
* Docker
* GitHub
* SQLite3
## 3.1. IT-infostructure
```mermaid
graph TD
    A(Start) --> B[Получить Оценки NFR в %<br/>Perf, Sec, Usab, Rel, Maint,<br/>Port, Supp, TTM];
    subgraph "Объяснение Сокращений"
      B_note[Perf: Производительность<br/>Sec: Безопасность<br/>Usab: Удобство<br/>Rel: Надежность<br/>Maint: Поддерживаемость<br/>Port: Переносимость<br/>Supp: Поддержка<br/>TTM: Скорость Разработки];
    end
    B --> C{TTM >= 80 and Maint < 40<br/>and Perf < 40 and Rel < 40?};

    C -- Да --> D[Рекомендация: Простая Монолитная Архитектура<br/><i>Макс. скорость старта,<br/>остальные NFR низкие</i>];
    C -- Нет --> E{Perf >= 80 and Rel >= 80<br/>and Maint >= 60?};

    E -- Да --> F[Рекомендация: Микросервисная Архитектура<br/><i>Высокие Perf/Rel/Maint</i>];
    F --> G{Нужна Экстрем. Эластичность?};
    G -- Да --> H[Рассмотреть: Бессерверная Архитектура / FaaS<br/><i>Как дополнение к Микросервисам</i>];
    G -- Нет --> I[Фокус на Микросервисной Архитектуре];
    H --> Z(End);
    I --> Z;

    E -- Нет --> J{Maint >= 80 and TTM < 80?};
    J -- Да --> K[Рассмотреть: Модульная Монолитная Архитектура<br/>ИЛИ Микроядерная Архитектура / Plugin<br/><i>Высокая Поддерживаемость</i>];
    J -- Нет --> L{TTM >= 60 and Maint >= 60<br/>and Perf < 60?};

    L -- Да --> M[Рекомендация: Модульная Монолитная Архитектура<br/><i>Баланс TTM и Maint,<br/>Perf не главное</i>];
    L -- Нет --> N{Perf > 60 and Rel > 60<br/>and Maint > 40?};

    N -- Да --> O[Оценить: Модульная Монолитная<br/>vs Микросервисная<br/><i>Сбалансированные NFR</i>];
    N -- Нет --> P{Sec >= 80?};

    P -- Да --> Q[Фокус на Безопасности<br/>внутри выбранной арх-ры];
    Q --> R[Переоценить другие NFR<br/>для выбора стиля];
    R --> S;

    P -- Нет --> S;

    S[Рекомендация по Умолчанию:<br/>Модульная Монолитная Архитектура<br/><i>Гибкий старт / Неясные NFR</i>];

    %% Окончание веток
    D --> Z;
    %% F -> G -> H/I -> Z (связи уже определены выше)
    K --> Z;
    M --> Z;
    O --> Z;
    S --> Z;

    Z(End);
```
## 3.2. Component Diagram (not implemented)


## 3.3. ERD Diagram (not implemented)

## 3.4. Class Diagram
```plantuml
@startuml
namespace task {
}
@enduml
```

## 3.5. File Structure (not implemented)
Тут можно добавить статистику 
* Сколько строчек кода
* Сложность функций
* Графики
* Сколько памяти занимает каждый файл
* Пояснение каждого файла

# Chapter 4. Testing and Results

## 4.1. Testing Methods (дерево решений)

## 4.2. Test Results 
* Таблица со всеми тестами
  * По памяти
  * По скорости (среднее время)
  * Логика
  * Какая часть кода была покрыта этим тестом
  * Input/Output

## 4.3. Results Analysis
* Графики
* Текстовый вывод

# Conclusion

# References

# Appendix A. Backend Code Listing

# Appendix B. Frontend Code Listing
