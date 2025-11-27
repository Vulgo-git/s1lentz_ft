# Janela PIX - Sistema de Pseudônimos

Implementação da janela PIX conforme especificação da seção 8 do documento técnico.

## Componentes

### Widgets Modulares

1. **PseudonymHeader** - Exibe o pseudônimo em destaque com badge VIP opcional
2. **OfficialReceiverInfo** - Mostra informações da instituição recebedora oficial
3. **PixKeyField** - Campo para exibir e copiar a chave PIX (com opção de mascarar)
4. **AmountSelector** - Seletor/editor de valor do pagamento
5. **StatusBanner** - Banner animado com status do pagamento
6. **PaymentInstructions** - Instruções passo-a-passo para realizar o pagamento

### Tela Principal

**PayToPseudonymScreen** - Tela completa que integra todos os componentes e gerencia:
- Conexão WebSocket para atualizações em tempo real
- Polling de fallback caso WebSocket falhe
- Confirmação manual de pagamento
- Estados de pagamento (waiting, pending, settled, failed)

## Uso

### Navegação Simples

```dart
import 'package:s1lentz/core/config/app_routes.dart';

// Navegar para a tela de pagamento
AppRoutes.navigateToPayToPseudonym(
  context,
  chargeId: 'charge-123',
  pseudonym: 'Maria',
  officialName: 'S1LENTZ TECNOLOGIAS LTDA',
  cnpj: '12.345.678/0001-00',
  pixKey: '+5511999999999',
  amount: 100.00, // opcional
  isVip: true, // opcional
  authToken: 'token-xyz', // opcional
);
```

### Navegação Direta

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PayToPseudonymScreen(
      chargeId: 'charge-123',
      pseudonym: 'Maria',
      officialName: 'S1LENTZ TECNOLOGIAS LTDA',
      cnpj: '12.345.678/0001-00',
      pixKey: '+5511999999999',
      amount: 100.00,
      isVip: true,
      authToken: 'token-xyz',
    ),
  ),
);
```

## Configuração

### WebSocket

A URL do WebSocket é construída automaticamente. Para configurar:

1. Edite o método `_buildWebSocketUrl()` em `pay_to_pseudonym_screen.dart`
2. Substitua `ws://localhost:8000/ws` pela URL real do seu backend

### API Service

Os métodos necessários já foram adicionados ao `ApiService`:
- `createCharge()` - Criar cobrança PIX
- `getChargeStatus()` - Verificar status da cobrança
- `confirmManualPayment()` - Confirmar pagamento manualmente

Certifique-se de configurar a `baseUrl` no `ApiService` para apontar para seu backend.

## Estados do Pagamento

- **waiting** - Aguardando pagamento
- **pending** - Pagamento pendente (webhook recebido, aguardando conciliação)
- **settled** - Pagamento confirmado e saldo creditado
- **failed** - Pagamento falhou ou foi rejeitado

## Recursos Implementados

✅ Componentes modulares conforme especificação  
✅ Integração WebSocket com reconexão automática  
✅ Polling de fallback (5s)  
✅ Confirmação manual de pagamento  
✅ Mascaramento de chave PIX (segurança)  
✅ Animações sutis para feedback visual  
✅ Notificações de sucesso/erro  
✅ Suporte a valores editáveis ou fixos  
✅ Badge VIP para recebedores VIP  
✅ Design seguindo tema dark/cyberpunk do projeto  
✅ Acessibilidade básica  

## Próximos Passos

1. Configurar URL real do WebSocket
2. Configurar URL base da API
3. Implementar autenticação no WebSocket (se necessário)
4. Adicionar testes unitários e de integração
5. Implementar cache local para estado do pagamento (opcional)

