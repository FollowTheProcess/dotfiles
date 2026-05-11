---
name: terraform
description: Use when writing, modifying, reviewing, or reading Terraform (HCL) code.
---

# Terraform

## Overview

Opinionated conventions for safe, minimal, well-typed Terraform modules. Configuration is data; expose the smallest knob surface that supports real use cases. Bad input should fail at parse, not at plan a day later in CI.

**RELATED SKILLS:** General test discipline (TDD, black-box testing, naming) lives in `tests` and `superpowers:test-driven-development`. This skill only adds Terraform-specific test notes.

## When to use

- Writing, modifying or reviewing any `.tf` / `.hcl` or `.tftest.hcl` file
- Designing a module's input or output surface

## Do

- **Format, lint, validate:** `terraform fmt -recursive`, `tflint` in the module directory, then `terraform validate`. All three must pass before ship. Ignore failures in `.terraform/modules/` (downloaded deps).
- **Pin everything.** `required_version` and every entry in `required_providers`. Commit `.terraform.lock.hcl`.
- **Specific types on every variable.** `object({...})`, `list(string)`, `map(...)`. Never `any` on a complex input.
- **`optional(T, default)`** for non-required object fields.
- **Validate inputs aggressively.** `validation` blocks with a concrete `condition` and a clear `error_message`.
- **Reject invalid combinations at the variable level.** If `enable_x = true` requires `x_arn`, enforce it with a `validation`.
- **Hardcode in `main.tf` over exposing a variable.** If you can't name a consumer that would set it differently, don't add the knob.
- **`for_each` over `count`.** Map keys survive reorders; `count` indexes don't.
- **`moved {}` blocks for renames or refactors.** Never destroy and recreate just to rename.
- **`removed {}` blocks when dropping a resource you want to keep.** With `lifecycle { destroy = false }` to only remove from state.
- **`import {}` blocks to adopt existing infra.** Reviewable in a PR, visible in `plan`. Imperative `terraform import` is neither.
- **`sensitive = true`** on variables and outputs holding secrets, tokens, ARNs, or PII.
- **One module, one purpose.** Outputs expose only what consumers need.
- **`data` sources for account ID, region, partition.** Never hardcode `123456789012` or `us-east-1`.
- **Default tags on the provider** (e.g. AWS `default_tags`) or a single tags module. Don't sprinkle `tags = merge(...)` across every resource.
- **Concise tests that guard invariants.** `terraform test` is verbose; use it only for what would silently break consumers (required outputs, validation rejection, key resource attributes).
- **Comments explain *why*.** A workaround, an upstream bug, a non-obvious ordering. Don't narrate what the HCL already says.
- **Early returns via `try()` / `coalesce()`** beat deeply nested ternaries.

## Don't

- **Don't expose a knob you can't safely combine.** If `var.a = true` requires `var.b = false`, that's a footgun, not a feature - constrain it or remove it.
- **Don't `depends_on` to paper over a missing reference.** Reference an attribute of B from A instead.
- **Don't reach for `null_resource` / `local-exec`** when a provider resource exists.
- **Don't manually edit state.** Use `moved`, `removed`, or an `import {}` block. `terraform state rm` and `terraform import` (the CLI) are last resorts, not workflows.
- **Don't use `count = var.enabled ? 1 : 0`** when `for_each` over a (possibly empty) set reads more clearly and survives future changes.
- **Don't test trivial wiring or upstream behaviour.** Test the contract *your* module promises.

## Rationalizations: when adding a variable

Common excuses for exposing a knob you shouldn't. If you catch yourself reaching for one, hardcode the literal in `main.tf` instead.

| Excuse                                              | Reality                                                                 |
|-----------------------------------------------------|-------------------------------------------------------------------------|
| "Flexibility for future deployments"                | Future deployments rarely materialize. Add the variable when a real consumer needs it; the change is small. |
| "Different deployments might answer differently"    | Name the deployment. If you can't, it's one answer.                     |
| "It's just one more knob"                           | One more knob is one more invalid combination and one more thing to validate. |
| "Upstream exposes it, so we should too"             | Upstream serves many consumers; this module may serve one operating model. Match yours, not theirs. |

## Quick reference

| Need                    | Pattern                                                  |
|-------------------------|----------------------------------------------------------|
| Format                  | `terraform fmt -recursive`                               |
| Lint (current module)   | `tflint` (don't `--recursive` into deps)                 |
| Validate                | `terraform validate`                                     |
| Run tests               | `terraform test`                                         |
| Rename a resource       | `moved { from = ... to = ... }`                          |
| Adopt existing infra    | `import { to = ... id = "..." }`                         |
| Drop without destroy    | `removed { from = ...  lifecycle { destroy = false } }`  |
| Optional object field   | `optional(string, null)`                                 |
| Reject bad input        | `validation { condition = ... error_message = ... }`     |
| Iterate a map           | `for k, v in var.things : k => ...`                      |
| Sensitive output        | `output "x" { value = ...; sensitive = true }`           |

## Validation pattern

```hcl
variable "cluster_name" {
  type        = string
  description = "EKS cluster name. <= 100 chars, DNS-1123 compatible."
  validation {
    condition     = length(var.cluster_name) <= 100 && can(regex("^[a-z0-9-]+$", var.cluster_name))
    error_message = "cluster_name must be <= 100 lowercase alphanumeric or hyphen characters."
  }
}

variable "logging" {
  type = object({
    enabled       = bool
    bucket_arn    = optional(string)
    retention_days = optional(number, 30)
  })
  validation {
    condition     = !var.logging.enabled || var.logging.bucket_arn != null
    error_message = "logging.bucket_arn is required when logging.enabled = true."
  }
}
```

The second block is the key pattern: cross-field constraints belong at the variable, not in plan-time errors.
