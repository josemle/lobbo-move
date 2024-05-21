module deploy_address::monad {


	// tyvar substitution test
	//

	inline fun id<T>(x: T): T {
		x
	}

	public fun test_id() {
		let f = id(3);
		let f = id(b"ciao");

		// i tipi freccia in Move esistono, ma hanno una sintassi bizzarra: |A|B equivale a A -> B
		// anche le lambda esistono, e sono espressioni aventi tipo freccia, ma sono macro che generano codice a compile time anziché essere vere chiusure a runtime
		// in generale, dunque, il supporto per la programmazione funzionale è limitato in Move (sia Sui che Aptos)
		let f = id(|x| x + 1);	// ERRORE: i generics non possono essere sostituiti con tipi freccia 
	}


	// i tipi freccia supportano il nesting, ergo il tipo A -> B -> C puo' essere scritto come |A|(|B|C)
	// c'e' un problema pero': nessun tipo freccia puo' comparire come tipo di ritorno di una funzione globale
	// attenzione: funzioni globali e lambda sono entita' distinte; una lambda puo' computare una lambda come risultato (ed avere frecce innestate a destra) ma una funzione globale non puo'
	// questa limitazione essenzialmente sgretola i nostri sogni di creazione di una monade di stato in Move
	// ma procediamo con altri esperimenti prima di addentrarci nelle monadi

	// currying test
	// 

	// (A * B -> C) -> A -> B -> C
	inline fun curry<A, B, C>(f: |A,B|C): |A|(|B|C) {	// ERRORE: non e' possibile avere un tipo freccia come tipo di ritorno
		|x| (|y| f(x, y)) // le lambda si possono innestare, tuttavia non sono valori di ritorno validi
	}

	// (A * B -> C) * A * B -> C
	inline fun curry__uncurried<A, B, C>(f: |A,B|C, x: A, y: B): C {	// facendo uncurrying della funzione curry si ottiene questo
		f(x, y)															// che non serve assolutamente a niente, perche' il senso e' convertire la funzione originale, non produrre il suo risultato
	}

	// (A -> B -> C) -> A * B -> C
	inline fun uncurry<A, B, C>(f: |A|(|B|C)): |A,B|C {		// ERRORE: non compila sempre per lo stesso motivo: non si possono avere tipi freccia come tipo di ritorno
		// non si puo' scrivere f(x)(y), e' un syntax error (perche' la chiamata a funzione non e' una applicazione con una espressione qualunque a sinistra)
		let g = |x| f(x);
		let h = g(x);
		h
	}

	// (A -> B -> C) * A * B -> C
	inline fun uncurry__uncurried<A, B, C>(f: |A|(|B|C), x: A, y: B): C {	// questo uncurrying della funzione uncurry e' di scarsa utilita' ma almeno si puo' fare
		let g = f(x);	
		g(y)
	}

	// state monad 
	//

	// S -> (S -> R * S) -> R * S
	inline fun run<S, R>(s: S, f: |S|(R, S)): (R, S) {	// questa e' l'unica che si riesce a scrivere, infatti e' triviale
		f(s)
	}

	// R -> S -> R * S
	inline fun ret<S, R>(r: R): |S|(R, S) {	// ERRORE: anche questa non compila perche' il tipo di ritorno non puo' essere una freccia
		|s| (r, s)
	}

	// (A -> S -> R * S) -> (S -> R * S) -> S -> R * S
	inline fun bind<A, S, R>(binder: |A|(|S|(R, S)), f: |S|(R, S)): |S|(R, S) {	// ERRORE: ovviamente neanche questa si puo' scrivere per il solito motivo
		//|s| (let (r, s') = run(s, f); run(s', binder(r)))	// ERRORE: non si possono mettere let dentro le lambda, quindi non si puo' implementare la bind cosi'
	}

	// state monad (uncurried)
	//

	// R -> S -> R * S
	inline fun ret__uncurried<S, R>(r: R, s: S): (R, S) {	// totalmente inutile
		(r, s)
	}

	// (A -> S -> R * S) -> (S -> R * S) -> S -> R * S
	inline fun bind__uncurried<A, S, R>(binder: |A|(|S|(R, S)), f: |S|(R, S), s: S): (R, S) {	// questa si puo' scrivere ma non e' molto utile
		let (r, s1) = run(s, f);
		run(s1, binder(r))
	}

}
