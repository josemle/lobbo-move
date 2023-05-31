import pyteal as pt
from beaker import Application, GlobalStateValue, LocalStateValue
from pathlib import Path

class LocalState:
    localInt = LocalStateValue(
        stack_type=pt.TealType.uint64
    )


app = Application(
    "LocalStateApp", state=LocalState()
)


@app.external
def set(input: pt.abi.Uint64) -> pt.Expr:
    return app.state.localInt.set(input.get())


@app.external
def get(*, output: pt.abi.Uint64) -> pt.Expr:
    return output.set(app.state.localInt)


app_spec = app.build()
output_dir = Path(__file__).parent / "artifacts/" / app_spec.contract.name
print(f"Dumping {app_spec.contract.name} to {output_dir}")
app_spec.export(output_dir)
