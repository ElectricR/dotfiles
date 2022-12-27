def end(failed_steps):
    if not len(failed_steps):
        print("Successfull bootstrap!")
        exit(0)
    for step in failed_steps:
        print(f"Step {step} didn't finish successfully")
    exit(1)


def bootstrap(steps):
    failed_steps = []
    for step in steps:
        exit_code = step()
        match exit_code:
            case 1:
                failed_steps.append(step.__name__)
            case 2:
                failed_steps.append(step.__name__)
                break
    end(failed_steps)
