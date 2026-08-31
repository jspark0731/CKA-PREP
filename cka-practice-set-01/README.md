# CKA Practice Set #1 — Killercoda

## Directory structure

```text
cka-practice-set-01/
├── README.md
├── q1/
│   └── question.md
├── q2/
│   └── question.md
├── ...
├── q15/
│   └── question.md
└── scripts/
    ├── set_question.sh
    ├── validate_question.sh
    └── cleanup_question.sh
```

## Usage

### 1. Prepare a question

```bash
./scripts/set_question.sh 1
```

### 2. Read the question

```bash
cat q1/question.md
```

### 3. Solve the problem

Use `kubectl`, YAML, official Kubernetes documentation, etc.

### 4. Validate

```bash
./scripts/validate_question.sh 1
```

### 5. Cleanup

```bash
./scripts/cleanup_question.sh 1
```

### Cleanup the whole set

```bash
./scripts/cleanup_question.sh all
```

## Typical workflow

```bash
./scripts/set_question.sh 7
cat q7/question.md

# solve Q7

./scripts/validate_question.sh 7
./scripts/cleanup_question.sh 7
```

## Notes

- Each question is intended to be independent.
- Run cleanup before moving to another question when possible.
- Q10 may print `SKIP` if the environment has no IngressClass.
- Q14 may print `SKIP` if the Killercoda scenario does not allow worker-node SSH/systemd control.
- Validators inspect final cluster state and, where practical, perform live connectivity/RBAC checks.

## Output behavior

`set_question.sh <N>`:
- prepares the environment
- immediately prints the question text

`validate_question.sh <N>`:
- prints the scoring items
- runs each validation check
- prints PASS/FAIL and score

`cleanup_question.sh <N>`:
- prints the resources/settings that will be removed or restored
- performs cleanup

Example:

```bash
./scripts/set_question.sh 7
./scripts/validate_question.sh 7
./scripts/cleanup_question.sh 7
```
