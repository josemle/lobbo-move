module deploy_address::break_linear {

  struct MyCoin has drop {
    value: u64
  }

  public fun f1(c: MyCoin): MyCoin {
    c
  }

  public fun f2(c: vector<MyCoin>): vector<MyCoin> {
    c
  }

  public fun f3(c: vector<u64>): vector<u64> {
    c
  }
  
  public fun f() {
    let c1 = MyCoin { value: 5000 };
    let MyCoin { value: n } = c1;
    let _c2 = f1(MyCoin { value: n + 1 });
    //f1(MyCoin { value: n + 3 });
  }
  

  public fun h(): vector<u64> {
    //let v1 = vector[ MyCoin { value: 2}, MyCoin { value: 3}];
    let v1 = vector[2, 4];
    let _v2 = f3(v1);
    let _v3 = f3(v1);
    _v3
  }

}