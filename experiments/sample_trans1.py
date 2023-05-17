# Sample Hello World Beaker smart contract - the most basic starting point for an Algorand smart contract
import beaker
import pyteal as pt

app = beaker.Application("SampleTrans1")

@pt.Subroutine(pt.TealType.uint64)
def g(x: pt.Expr, y: pt.Expr) -> pt.Expr:
    return pt.Mul(x, y)

@pt.Subroutine(pt.TealType.uint64)
def f(x: pt.Expr) -> pt.Expr:
    return g(pt.Add(x, pt.Int(4)), pt.Add(pt.Int(8), pt.Int(10)))

@app.external
def main(*, output: pt.abi.Uint64) -> pt.Expr:
    return output.set(f(pt.Int(1)))
