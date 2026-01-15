# Pull Request Feedback

Super Important: Be DIPLOMATIC.

## Background

Provide pull request feedback to different projects and version controlled repositories.

## Checklist

The code review process aims to ensure that the delivered code meets the story’s **Acceptance Criteria (AC)** and that the codebase stays **consistent**, **maintainable**, and **understandable**.

The goal is not to find the **“perfect”** code; there is only better code. Reviewers should balance forward progress with the importance of suggested changes.

---

## Functionality

Code reviewers must ensure the pull request (PR) passes all Acceptance Criteria. This is **in addition** to the author’s own testing.

Reviewers should focus on:
- Edge cases or bugs the author may have missed
- Performance and security concerns
- User experience (think from the user’s perspective)

---

## Conventions

There are no magic rules, but naming matters:
- Names must be descriptive without being overly long
- Avoid meaningless names (`a`, `i`, etc.)
- Follow standard naming conventions for the stack

> ℹ️ Learn more about naming conventions  
> https://nimblehq.co/compass/development/code-conventions/#naming

Ensure all language-specific conventions are followed:  
https://nimblehq.co/compass/development/code-conventions/

---

## Testing

Testing is required. Reviewers must ensure:
- Tests exist for new or modified code
- Tests are well-designed and meaningful

https://nimblehq.co/compass/development/testing/

---

## Positive Areas

Reviewers should acknowledge good work, for example:
- Clear PR description that makes review easy
- Thoughtful handling of edge cases
- Practical algorithms that simplify complex logic

---

## Processing Pull Requests

### High-level Review

- Check PR title and description  
  Does it follow the correct structure?
  https://nimblehq.co/compass/development/code-reviews/pull-request-authoring/#structure
- Review the linked story/issue and Acceptance Criteria
- Do **What happened?** and **Insights** explain the approach clearly?
- Does **Proof of Work** show the feature working and match design/flow?
- Review **Files changed** for architectural, UX, or legacy impact issues

---

### Build and Test

CI should already pass. Reviewer focuses on:
- UI matches design
- Feature works correctly
- Edge cases are handled

---

## Providing Feedback

### Courteous Language

- Be kind
- Be explicit (intent is not always clear online)
- Be humble (`I’m not sure — let’s look it up`)
- Ask for clarification (`Can you clarify this?`)
- Avoid ownership language (`mine`, `yours`, `not mine`)
- Avoid demands
- Avoid subjective opinions
- Avoid personal trait language (`dumb`, `stupid`)
- Avoid hyperbole (`always`, `never`, `nothing`)

**Bad**
```md
@user_id -> This solution is better compared to yours
