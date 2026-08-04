# Handoff

Persistence: use `goal-handoff-persistence`; goal <=6000 bytes; handoff <=64000 bytes.

## Current Snapshot

- The learner understands that likelihood holds observed data fixed and scores parameter values.
- The learner can derive a Bernoulli likelihood and convert it to log-likelihood, but still hesitates when support depends on the parameter.

### Working Understanding

- The next example must make the parameter-dependent support visible before differentiation; this is the missing step, not algebra or the log transformation.

## Decisions And Constraints

- Continue from first principles and connect every formula to meaning; do not introduce asymptotic theory yet.

## Next Action

1. Teach one support-dependent example, then contrast it with the Bernoulli case.
