import beaker
import pyteal as pt


class ExampleState:
    global_bytearr = beaker.GlobalStateValue(
        stack_type=pt.TealType.bytes,
        key="bytearr_key",
        default=pt.Bytes(""),
        descr="Bytes array",
    )

    global_u64 = beaker.GlobalStateValue(
        stack_type=pt.TealType.uint64,
        key="u64_key",
        default=pt.Int(0),
        descr="uint64 global var",
    )

app = beaker.Application("StateExample", state=ExampleState())


@app.external
def set_global_state_val(v: pt.abi.String, n: pt.abi.Uint64) -> pt.Expr:
    return pt.Seq(app.state.global_bytearr.set(v.get()), app.state.global_u64.set(n.get()))

@app.external
def foo(a: pt.abi.Uint64, b: pt.abi.Uint64, c: pt.abi.Uint64, *, output: pt.abi.Uint64) -> pt.Expr:
    return output.set(pt.Add(a.get(), b.get(), c.get()))

@app.external(read_only=True)
def get_global_state_val(*, output: pt.abi.String) -> pt.Expr:
    return output.set(app.state.global_bytearr)

@app.external(read_only=True)
def get_global_state_tuple(*, output: pt.abi.Tuple3[pt.abi.Uint64, pt.abi.String, pt.abi.Uint64]) -> pt.Expr:
    num = pt.abi.Uint64()
    bytearr = pt.abi.String()
    num.set(app.state.global_u64.get())
    bytearr.set(app.state.global_bytearr.get())
    return output.set(num, bytearr, num)

@pt.Subroutine(pt.TealType.uint64)
def bar(a: pt.Expr, b: pt.Expr) -> pt.Expr:
    return pt.Add(a, b)

@app.external
def call_bar(a: pt.abi.Uint64, b: pt.abi.Uint64, *, output: pt.abi.Uint64) -> pt.Expr:
    return output.set(bar(a.get(), b.get()))
