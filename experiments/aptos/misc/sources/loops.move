module deploy_address::loops {
  
    public fun infiniteLoop() {
        let i = 0;
        loop {
            i = i + 1;
        }
    }

    public fun finiteLoop(n: u64) {
        let i = 0;
        while (i < n) {
            i = i + 1;
        } 
    }
}