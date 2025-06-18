export interface Transaction {
  registro_id: string;
  created_at: string;
  descricao: string;
  categoria: string;
  tipo: 'Entrada' | 'Saída';
  valor: number;
  user_id: string;
}

export interface User {
  user_id: string;
  created_at: string;
  nome: string;
  email: string;
  fotoPerfil?: string;
}

export interface CategoryIcon {
  [key: string]: string;
}